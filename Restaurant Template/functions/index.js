const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.setOwnerClaim = functions.https.onCall(async (data, context) => {
  try {
    // Log the incoming data
    console.log('Received data:', data);
    
    // Check if uid exists in the data (single level nesting)
    const uid = data?.data?.uid || data?.uid; // fallback in case structure changes
    if (!uid) {
      throw new functions.https.HttpsError('invalid-argument', 'Missing uid');
    }

    console.log('Setting owner claim for user:', uid);
    
    // Set the custom claim
    await admin.auth().setCustomUserClaims(uid, { owner: true });
    console.log('Successfully set owner claim');
    
    return { success: true };
  } catch (error) {
    console.error('Error:', error);
    throw new functions.https.HttpsError('internal', error.message);
  }
});