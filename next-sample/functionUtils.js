export const getCurrentDateTime = () => {
    const now = new Date();
    const kst = new Date(now.getTime() + (now.getTimezoneOffset() * 60000) + 9 * 3600000); // KST (UTC+9)
    const year = kst.getFullYear();
    const month = (kst.getMonth() + 1).toString().padStart(2, "0");
    const day = kst.getDate().toString().padStart(2, "0");
    const hours = kst.getHours().toString().padStart(2, "0");
    const minutes = kst.getMinutes().toString().padStart(2, "0");
    const seconds = kst.getSeconds().toString().padStart(2, "0");

    return year + month + day + hours + minutes + seconds;
}

export const random = () => {
    return Math.floor(Math.random() * 1000);
}