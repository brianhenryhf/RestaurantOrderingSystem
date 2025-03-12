// TODO some way to populate entries in build
const entries = {
  API_BASE_URL: 'http://127.0.0.1:3000'
};

export const config = {
  get: (entryName) => entries[entryName],
  // keys
  API_BASE_URL: 'API_BASE_URL',
}
