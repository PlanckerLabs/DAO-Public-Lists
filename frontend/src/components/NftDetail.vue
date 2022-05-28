// replace nft
<template>
  <el-drawer
      custom-class="nftdetaildrawer"
      v-model="nftdetaildrawer"
      :with-header="false"
      :close-on-click-modal="false" 
      destroy-on-close 
      direction="btt">
    <div class="cbox">
      <div class="cdleft">
        <el-image class="nftimg" :src="nftinfo.uri"
                  fit="fill"/>
        <div class="nfttext">{{nftinfo.name}}</div>
        <div class="nftisused">Holder：{{nftinfo.approved}}</div>
      </div>
      <div class="cdright">
        <div class="topbtlist">
            <span :class="{ nftbtcur:listfiltertype=='all' }" @click="filterlist('all')" class="nftfilterbt nftbtf ">
                All({{req.rejected + req.approved + req.pending}})
            </span>
            <span :class="{ nftbtcur:listfiltertype=='rejected' }" @click="filterlist('rejected')" class="nftfilterbt">
                Rejected({{req.rejected}})
            </span>
            <span :class="{ nftbtcur:listfiltertype=='approved' }" @click="filterlist('approved')" class="nftfilterbt">
                Approved({{req.approved}})
                </span>
            <span :class="{ nftbtcur:listfiltertype=='pending' }" @click="filterlist('pending')" class="nftfilterbt nftbte">
                Pending({{req.pending}})
            </span>
        </div>
        <div class="listhead">
          <span class="span1">Number</span>
          <span class="span2">Time</span>
          <span class="span3">Address</span>
          <span class="span4">Remarks</span>
          <span class="span5">Status</span>
          <span class="span6">Operation</span>
        </div>
        <div class="listcontent">
          <div class="reqline" v-for="item in reqlist">
            <span class="span1">{{ item.Number }}</span>
            <span class="span2">{{ item.Time }}</span>
            <span class="span3">{{ item.Address }}</span>
            <span class="span4">{{ item.Remarks }}</span>
            <span class="span5">{{ item.Status }}</span>
            <span class="span6" v-if="item.Status!='pending'">/</span>
            <span class="span6" v-if="item.Status=='pending'">
                <span class="reqpass" @click="excutereq('pass',item.Index)">Approve</span>
                <span class="reqreject" @click="excutereq('reject',item.Index)">Reject</span>
            </span>
          </div>
        </div>
        <div class="listpage">
          <span v-for="item in pageset.pages" 
          :class="{curpage:item.page==pageset.curpage}"
          @click="changepage(item.page)">{{item.txt}}</span> 
        </div>
      </div>
    </div>

    <div class="drawerhead">
      <span class="headclose" @click="nftdetaildrawer=false">close</span>
    </div>
  </el-drawer>
</template>
<script setup> 
import {reactive, toRefs,ref, onMounted, watch } from "vue";  
import useWeb3 from "/src/utils/useWeb3";
import bridgeabi from '/src/assets/abi/soulBoundBridge.json';
import daoabi from '/src/assets/abi/soulBoundMedal.json';
import {ElLoading,ElNotification} from 'element-plus';  
const {account, web3, ContractCall, ContractSend ,bridge } = useWeb3();
let contractaddress = '';
let nftdetaildrawer = ref(false);
let req = ref({});
let nftinfo = ref({
    name:'',
    url:''
});
let reqlist = ref('');
let pageset = ref({});
reqlist.value = [];

let alldata = []; 
let statustype = {
    0: 'error', 
    1: 'pending', 
    2: 'rejected', 
    3: 'approved'
};
let listfiltertype = ref('all');

function filterlist(curfilter,isini = false,setcurpage = 1) {
    listfiltertype.value = curfilter;  
    reqlist.value = [];
    let recordindex = 1;
    for( let a in alldata )
    { 
        let currecord = alldata[ a ];
        if( nftinfo.value.index != currecord.medalindex )
        {
            continue;
        }
        let statusnum = currecord.status>2?3:currecord.status;
        let curstatus = statustype[ statusnum ];
        if( listfiltertype.value == curstatus || listfiltertype.value == 'all' )
        { 
            let addnox = currecord.address.substring(2);
            let curaddress = "0x" + addnox.padStart(40,'0');
            let addresslen = curaddress.length;
            reqlist.value.push(
            {
                Index: currecord.index,
                Number: recordindex++,
                Time: getFormatTs( currecord.timestamp*1000 ),
                Address: curaddress.substring(0,6) + '...'+ curaddress.substring(addresslen-4,addresslen),
                Remarks: '',
                Status: curstatus,
                Operation: null
            });
            if( listfiltertype.value == 'all' && isini )
            {
                if( statustype[ statusnum ] )
                {
                    req.value[ statustype[ statusnum ] ]++;
                } 
            }
        }
    }
    pageset.value = {
        curpage:1,
        total:0,
        pages:[]
    }; 
    pageset.value.total = Math.ceil( reqlist.value.length/10 );
    changepage(setcurpage);
}
function getFormatTs(value) {
    let date = new Date(value);
    let y = date.getFullYear();
    let MM = date.getMonth() + 1;
    MM = MM < 10 ? "0" + MM : MM;
    let d = date.getDate();
    d = d < 10 ? "0" + d : d;
    return y + "-" + MM + "-" + d;
}
const read = async ( arr , funcname, s ) => { 
    const loading = ElLoading.service({
        lock: true,
        text: 'Loading',
        background: 'rgba(0, 0, 0, 0.7)',
    })
    return await ContractCall(bridgeabi, s, funcname, arr).then((res) => {
        loading.close();
        return res;
    }).catch(() => {
        loading.close();
    })
} 
let curexecute = '';
function excutereq( mtype, nftindex ) {
    if( curexecute === nftindex )
    {
        return;
    }
    curexecute = nftindex; 
    let methodstypes = {
        pass : 'cliamApproved',
        reject : 'cliamRejected',
    };
    const loading = ElLoading.service({
        lock: true,
        text: 'Loading',
        background: 'rgba(0, 0, 0, 0.7)',
    })
    ContractSend(daoabi, contractaddress , methodstypes[ mtype ], [ nftindex ]).then((res) => {
        curexecute = '';
        loading.close();
        ElNotification({
            title: 'Success',
            message: 'blockHash:' + res.blockHash,
            type: 'success',
            duration: 3000
        })
        loaddata( 'all', 1 );
    }).catch((e) => {
        curexecute = '';
        loading.close();
    })
}
function changepage( curpage )
{
    pageset.value.curpage = curpage; 
    var pageCount = pageset.value.total;
    let totalbt = 7;
    pageset.value.pages = [];
    var beginpage, endpage; 
    if (pageCount > totalbt) { 
        if (curpage - parseInt(totalbt / 2) < 1) { 
            beginpage = 1;
            endpage = beginpage + totalbt - 1;
        } else {
            beginpage = curpage - parseInt(totalbt / 2);
            endpage = curpage + parseInt(totalbt / 2);
        }
        if (endpage >= pageCount) {

            endpage = pageCount;
        }
        if (endpage - curpage < parseInt(totalbt / 2)) {        
            endpage = pageCount;
            beginpage = pageCount - totalbt + 1;
        }
        else if (curpage - beginpage < parseInt(totalbt / 2)) {
            beginpage = 1;
            endpage = beginpage + totalbt - 1;
        }
        else {
            beginpage = curpage - parseInt(totalbt / 2);
            endpage = curpage + parseInt(totalbt / 2);
        }
    }
    else if (pageCount <= totalbt) { 
        beginpage = 1;
        endpage = pageCount;
    }
    for (var i = beginpage; i <= endpage; i++) { 
        pageset.value.pages.push({
            page: i,
            txt: i
        });
    }


}
async function loaddata( filtertype = 'all',setcurpage = 1 )
{
    alldata = await read( [ contractaddress, 0, 999 ], 'getCliamRequest', bridge );
    alldata = JSON.parse( alldata ); 
    nftdetaildrawer.value = true;  
    req.value = { 
        rejected:0,
        approved:0,
        pending:0
    };
    filterlist( filtertype, true, setcurpage );
}
const showdrawer = async function( contract_address, nftobj )
{ 
    contractaddress = contract_address;
    nftinfo.value = nftobj;
    loaddata( 'all', 1 );
    // pushdata();
}
defineExpose({
  showdrawer
})
</script>
<style>
.nftdetaildrawer {
  height: auto !important;
  top: 3.33rem;
  bottom: 0;
  border-radius: 1.67rem 1.67rem 0rem 0rem;
}

.nftdetaildrawer .el-drawer__body {
  padding: 0px;
}
</style>
<style scoped>
.listhead {
  margin: 1.67rem 0 0 3.33rem;
  height: 2.5rem;
  line-height: 2.5rem;
  font-size: 0.67rem;
  font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 500;
  color: #999999;
  border-bottom: solid #EEEEEE 0.04rem;
}

.listcontent {
  margin: 0 0 1.67rem 3.33rem;
}

.listhead span, .reqline span {
  width: 6.8rem;
  display: inline-block;
}

.listhead .span1, .reqline .span1 {
  width: 6.3rem;
  padding-left: 1.33rem;
}

.listhead .span2, .reqline .span2 {
  width: 6.3rem;
}

.listhead .span3, .reqline .span3 {
  width: 6.8rem;
}

.listhead .span5, .reqline .span5 {
  width: 6rem;
}

.listhead .span6, .reqline .span6 {
  width: 6rem;
}

.reqline {
  min-height: 2.5rem;
  font-size: 0.67rem;
  font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 500;
  color: #000000;
  line-height: 2.5rem;
  border-bottom: solid #EEEEEE 0.04rem;
}

.span6 .reqpass {
  width: 3rem;
  display: inline-block;
  color: #6E3FF5;
  cursor: pointer;
  text-decoration: underline;
}

.span6 .reqreject {
  width: 3rem;
  display: inline-block;
  color: #F53F3F;
  cursor: pointer;
  text-decoration: underline;
}

.listpage {
  text-align: right;
}

.listpage span {
  display: inline-block;
  min-width: 1.33rem;
  height: 1.33rem;
  line-height: 1.33rem;
  background: #FFFFFF;
  border-radius: 0.08rem;
  border: 0.04rem solid #999999;
  text-align: center;


  font-size: 0.5rem;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #000000;
  margin-left: 0.5rem;
  cursor: pointer;
}

.listpage span.curpage {
  border: 0.04rem solid #6E3FF5;
  color: #6E3FF5;
}
</style>
<style lang="scss" scoped>
* {
  color: #999999;
  font-size: 0.83rem;
}

.drawerhead {
  position: absolute;
  right: 0;
  top: 0;
}

.cbox {
  height: 100%;
  width: 100%;
}

.cdleft {
  width: 30.33rem;
  background: #F5F5F5;
  height: 100%;
  position: absolute;
  top: 0;
}

.cdright {
  left: 30.33rem;
  height: 100%;
  position: absolute;
  top: 0;
  right: 3.33rem;
}

.nftimg {
  width: 23.5rem;
  height: 23.5rem;
  margin-left: 3.33rem;
  margin-top: 3.67rem;
}

.nfttext {
  margin-left: 3.33rem;
  margin-top: 0.83rem;
  height: 2.33rem;
  font-size: 1.67rem;
  font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 500;
  color: #000000;
  line-height: 2.33rem;
}

.nftisused {
  margin-left: 3.33rem;
  height: 1.75rem;
  font-size: 1.25rem;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #999999;
  line-height: 1.75rem;
}

.topbtlist {
  margin: 3.67rem 0 0 3.33rem;
}

.nftfilterbt.nftbtcur {
  background: #6E3FF5;
  border: none;
  color: #FFFFFF;
  height: 2.58rem;
}

.nftfilterbt {
  font-size: 0.67rem;
  font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 500;
  width: 7.67rem;
  height: 2.5rem;
  border: 0.04rem solid #EEEEEE;
  color: #999999;
  text-align: center;
  vertical-align: top;
  display: inline-grid;
  align-items: center;
  word-wrap: break-word;
  white-space: pre-wrap;
  cursor: pointer;
}

.nftbtf {
  border-radius: 0.33rem 0rem 0rem 0.33rem;
}

.nftbte {
  border-radius: 0rem 0.33rem 0.33rem 0rem;
}


.headclose {
  height: 1rem;
  font-size: 0.71rem;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #F53F3F;
  margin: 1.67rem 1.67rem 0 0;
  line-height: 1rem;
  float: right;
  cursor: pointer;
}
</style>
