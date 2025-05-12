const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function createAndSetOwnerRole(email, password) {
  try {
    // First try to create the user
    let user;
    try {
      user = await admin.auth().createUser({
        email: email,
        password: password,
        emailVerified: true
      });
      console.log(`Successfully created user: ${email}`);
    } catch (createError) {
      // If user already exists, get the user
      if (createError.code === 'auth/email-already-exists') {
        user = await admin.auth().getUserByEmail(email);
        console.log(`User already exists: ${email}`);
      } else {
        throw createError;
      }
    }
    
    // Set the owner claim
    await admin.auth().setCustomUserClaims(user.uid, { owner: true });
    console.log(`Successfully set owner claim for ${email}`);
    
    // Verify the claim was set
    const userRecord = await admin.auth().getUser(user.uid);
    console.log('User claims:', userRecord.customClaims);
  } catch (error) {
    console.error('Error:', error);
  }
}

// Replace with your desired owner email and password
createAndSetOwnerRole("123@123.com", "123456");
