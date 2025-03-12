// UI formatting utils

/** format US cents to dollars */
export const formatPrice = (cents) => {
  if (cents == null) return '--';

  return `$${(cents / 100).toLocaleString(undefined, {minimumFractionDigits: 2})}`;
}

// quick demo impl
export const formatTimestamp = (timestampStr) => {
  return new Date(timestampStr).toLocaleString();
}