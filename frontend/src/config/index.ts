import dev from "./dev";
import prod from "./prod";

// 是否开发模式
export const isDev = import.meta.env.MODE === "development";

export const config = {
    // 当前环境
    ...(isDev ? dev : prod)
}
