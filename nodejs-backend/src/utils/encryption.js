const CryptoJS = require("crypto-js");

const SECRET_KEY =
  "MNq0bpr8AzJ4sqPp3m9JmdaqGWtjNKm8iQ==";

// Encrypt data
function encryptData(data) {
  try {
    if (!data) throw new Error("No data provided for encryption");
    const ciphertext = CryptoJS.AES.encrypt(
      JSON.stringify(data),
      SECRET_KEY,
    ).toString();
    return ciphertext;
  } catch (error) {
    console.error("Encryption error:", error);
    throw error;
  }
}

function decryptData(ciphertext) {
  try {
    if (!ciphertext) throw new Error("No ciphertext provided for decryption");
    const bytes = CryptoJS.AES.decrypt(ciphertext, SECRET_KEY);
    const decryptedData = bytes.toString(CryptoJS.enc.Utf8);
    if (!decryptedData) throw new Error("Decryption failed - empty result");
    return JSON.parse(decryptedData);
  } catch (error) {
    console.error("Decryption error:", error);
    throw error;
  }
}

// FeathersJS Hook - Encrypt Response
const encryptResponse = async (context) => {
  if (context.result) {
    if (!context.result.encrypted) {
      context.result = { encrypted: encryptData(context.result) };
    }
  }
  return context;
};

// FeathersJS Hook - Decrypt Request
const decryptRequest = async (context) => {
  if (context.data && context.data.encrypted) {
    context.data = decryptData(context.data.encrypted);
  }
  return context;
};

// FeathersJS Hook - Decrypt Response
const decryptResponse = async (context) => {
  if (context.result && context.result.encrypted) {
    context.result = decryptData(context.result.encrypted);
  }
  return context;
};

module.exports = {
  encryptData,
  decryptData,
  encryptResponse,
  decryptRequest,
  decryptResponse,
};
