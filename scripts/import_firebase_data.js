/**
 * Firebase Firestore Mock Data Import Script
 * 
 * This script imports mock data into Firebase Firestore.
 * 
 * Prerequisites:
 * 1. Install Firebase Admin SDK: npm install firebase-admin
 * 2. Create a service account key from Firebase Console
 * 3. Set GOOGLE_APPLICATION_CREDENTIALS environment variable or pass credentials
 * 
 * Usage:
 * node scripts/import_firebase_data.js
 */

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Initialize Firebase Admin
// Option 1: Use service account key file
// const serviceAccount = require('./path/to/serviceAccountKey.json');
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount)
// });

// Option 2: Use environment variable GOOGLE_APPLICATION_CREDENTIALS
// admin.initializeApp();

// Option 3: Initialize with project ID (for emulator or default credentials)
try {
  admin.initializeApp({
    projectId: 'your-project-id' // Replace with your Firebase project ID
  });
} catch (error) {
  console.log('Firebase already initialized:', error.message);
}

const db = admin.firestore();

// Load mock data
const mockDataPath = path.join(__dirname, '..', 'firebase_mock_data.json');
const mockData = JSON.parse(fs.readFileSync(mockDataPath, 'utf8'));

// Helper function to convert date strings to Firestore Timestamps
function convertToTimestamp(dateString) {
  if (!dateString) return null;
  return admin.firestore.Timestamp.fromDate(new Date(dateString));
}

// Helper function to convert nested objects recursively
function convertTimestamps(obj) {
  if (obj === null || obj === undefined) return obj;
  
  if (typeof obj === 'string' && obj.match(/^\d{4}-\d{2}-\d{2}T/)) {
    // Check if it's a date string
    try {
      return convertToTimestamp(obj);
    } catch (e) {
      return obj;
    }
  }
  
  if (Array.isArray(obj)) {
    return obj.map(item => convertTimestamps(item));
  }
  
  if (typeof obj === 'object') {
    const converted = {};
    for (const key in obj) {
      if (obj.hasOwnProperty(key)) {
        converted[key] = convertTimestamps(obj[key]);
      }
    }
    return converted;
  }
  
  return obj;
}

// Import users
async function importUsers() {
  console.log('Importing users...');
  const users = mockData.users;
  let batch = db.batch();
  let count = 0;
  let batchCount = 0;

  for (const userId in users) {
    const userData = convertTimestamps(users[userId]);
    const userRef = db.collection('users').doc(userId);
    batch.set(userRef, userData);
    batchCount++;
    count++;
    
    if (batchCount >= 500) {
      await batch.commit();
      console.log(`  Imported ${count} users...`);
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }
  console.log(`✓ Imported ${count} users`);
}

// Import pets
async function importPets() {
  console.log('Importing pets...');
  const pets = mockData.pets;
  let batch = db.batch();
  let count = 0;
  let batchCount = 0;

  for (const petId in pets) {
    const petData = convertTimestamps(pets[petId]);
    const petRef = db.collection('pets').doc(petId);
    batch.set(petRef, petData);
    batchCount++;
    count++;
    
    if (batchCount >= 500) {
      await batch.commit();
      console.log(`  Imported ${count} pets...`);
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }
  console.log(`✓ Imported ${count} pets`);
}

// Import feeding points
async function importFeedingPoints() {
  console.log('Importing feeding points...');
  const feedingPoints = mockData.feedingPoints;
  let batch = db.batch();
  let count = 0;
  let batchCount = 0;

  for (const pointId in feedingPoints) {
    const pointData = convertTimestamps(feedingPoints[pointId]);
    const pointRef = db.collection('feedingPoints').doc(pointId);
    batch.set(pointRef, pointData);
    batchCount++;
    count++;
    
    if (batchCount >= 500) {
      await batch.commit();
      console.log(`  Imported ${count} feeding points...`);
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }
  console.log(`✓ Imported ${count} feeding points`);
}

// Import vaccinations
async function importVaccinations() {
  console.log('Importing vaccinations...');
  const vaccinations = mockData.vaccinations;
  let batch = db.batch();
  let count = 0;
  let batchCount = 0;

  for (const vaccId in vaccinations) {
    const vaccData = convertTimestamps(vaccinations[vaccId]);
    const vaccRef = db.collection('vaccinations').doc(vaccId);
    batch.set(vaccRef, vaccData);
    batchCount++;
    count++;
    
    if (batchCount >= 500) {
      await batch.commit();
      console.log(`  Imported ${count} vaccinations...`);
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }
  console.log(`✓ Imported ${count} vaccinations`);
}

// Import conversations
async function importConversations() {
  console.log('Importing conversations...');
  const conversations = mockData.conversations;
  let batch = db.batch();
  let count = 0;
  let batchCount = 0;

  for (const convId in conversations) {
    const convData = convertTimestamps(conversations[convId]);
    const convRef = db.collection('conversations').doc(convId);
    batch.set(convRef, convData);
    batchCount++;
    count++;
    
    if (batchCount >= 500) {
      await batch.commit();
      console.log(`  Imported ${count} conversations...`);
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }
  console.log(`✓ Imported ${count} conversations`);
}

// Import messages (subcollection)
async function importMessages() {
  console.log('Importing messages...');
  const conversationsMessages = mockData.conversations_messages;
  let totalCount = 0;

  for (const convId in conversationsMessages) {
    const messages = conversationsMessages[convId];
    let batch = db.batch();
    let count = 0;
    let batchCount = 0;

    for (const msgId in messages) {
      const msgData = convertTimestamps(messages[msgId]);
      const msgRef = db.collection('conversations')
        .doc(convId)
        .collection('messages')
        .doc(msgId);
      batch.set(msgRef, msgData);
      batchCount++;
      count++;
      totalCount++;
      
      if (batchCount >= 500) {
        await batch.commit();
        console.log(`  Imported ${count} messages for conversation ${convId}...`);
        batch = db.batch();
        batchCount = 0;
      }
    }

    if (batchCount > 0) {
      await batch.commit();
    }
  }
  console.log(`✓ Imported ${totalCount} messages`);
}

// Import likes
async function importLikes() {
  console.log('Importing likes...');
  const likes = mockData.likes;
  let batch = db.batch();
  let count = 0;
  let batchCount = 0;

  for (const likeId in likes) {
    const likeData = convertTimestamps(likes[likeId]);
    const likeRef = db.collection('likes').doc(likeId);
    batch.set(likeRef, likeData);
    batchCount++;
    count++;
    
    if (batchCount >= 500) {
      await batch.commit();
      console.log(`  Imported ${count} likes...`);
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }
  console.log(`✓ Imported ${count} likes`);
}

// Main import function
async function importAll() {
  try {
    console.log('Starting Firebase import...\n');
    
    await importUsers();
    await importPets();
    await importFeedingPoints();
    await importVaccinations();
    await importConversations();
    await importMessages();
    await importLikes();
    
    console.log('\n✓ All data imported successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error importing data:', error);
    process.exit(1);
  }
}

// Run import
importAll();

