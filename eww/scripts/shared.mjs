/**
 * @param {() => string} callback 
 * @param {number} refreshTime 
 */
export const run = async (callback, refreshTime = 50) => {
  let cacheText = ''

  while (true) {
    let message = ''

    message = callback().trim().replaceAll("\n", " ");

    if (cacheText !== message) {
      cacheText = message;
      console.log(message);
    }

    await new Promise((resolve) => setTimeout(resolve, refreshTime));
  }
};
