/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const {onRequest} = require("firebase-functions/v2/https");

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /messages/:documentId/original

/**
 * Auto assigns tasks to volunteers. This function
 * is triggered on an HTTP request and will assign tasks
 * to volunteers based on their availability and the task deadline.
 * It retrieves all tasks with status "open" and
 * all volunteers, then it assigns tasks to volunteers who
 * are available within the task's deadline. It
 * sorts the volunteers by the task count and assigns the task
 * to the volunteer with the lowest task count.
 * Finally, it sends back the tasks with assigned volunteers
 * and the tasksVolunteersMap to the client.
 *
 * @async
 * @param {Object} data - The data passed to the function.
 * @param {Object} context - The context passed to the function.
 * @returns {Object} An object containing tasks
 * with assigned volunteers and the tasksVolunteersMap.
 */
exports.autoAssign = onRequest(async (req, res) => {
  /**
   * Checks if a volunteer is available within the deadline of a task.
   * This function compares the volunteer's available
   * dates with the task's deadline and returns true if there
   * is at least one date where  the volunteer is available.
   *
   * @param {Object} volunteer - The volunteer object.
   *  It should have an 'availabledates' array property.
   * @param {Object} task - The task object. It should
   * have a 'deadline' array property.
   * @return {boolean} Returns true if the volunteer
   * is available within the task's deadline, false otherwise.
   */
  function isAvailableWithinDeadline(volunteer, task) {
    return volunteer.availabledates.some((date) => {
      const availableDate = date.toDate();

      const availableDateOnly = new Date(
          availableDate.getFullYear(),
          availableDate.getMonth(),
          availableDate.getDate(),
      );

      const startDeadline = task.deadline[0].toDate();
      const startDeadlineOnly = new Date(
          startDeadline.getFullYear(),
          startDeadline.getMonth(),
          startDeadline.getDate(),
      );

      const endDeadline = task.deadline[1].toDate();
      const endDeadlineOnly = new Date(
          endDeadline.getFullYear(),
          endDeadline.getMonth(),
          endDeadline.getDate(),
      );

      return (
        availableDateOnly.getTime() >= startDeadlineOnly.getTime() &&
        endDeadlineOnly.getTime() >= availableDateOnly.getTime()
      );
    });
  }

  // Push the new message into Firestore using the Firebase Admin SDK.
  const firestore = getFirestore();

  // Get all tasks with status "open"
  const tasksSnapshot = await firestore
      .collection("tasks")
      .where("status", "==", "Open")
      .get();

  console.log("Retrieved tasks:", tasksSnapshot.docs.length);

  // Convert the Snapshot into an array of task documents.
  const openTasks = tasksSnapshot.docs.map((doc) => doc.data());

  // Get all volunteers
  const volunteersSnapshot = await firestore.collection("users").get();

  console.log("Retrieved volunteers:", volunteersSnapshot.docs.length);

  // Convert the Snapshot into an array of volunteer documents.
  const allVolunteers = volunteersSnapshot.docs.map((doc) => doc.data());

  const tasksVolunteersMap = {};

  let availableTasks = openTasks.map((task) => {
    const availableVolunteers = allVolunteers
        .filter((volunteer) => isAvailableWithinDeadline(volunteer, task))
        .sort((a, b) => a.taskcount - b.taskcount);

    if (availableVolunteers.length > 0) {
      // Assign the reference ID of the first available volunteer
      // (with the lowest task count) to the task's assignedTo attribute
      task.assignedto = availableVolunteers[0].referenceId;

      // Increase taskcount of assigned volunteer
      availableVolunteers[0].taskcount += 1;

      // Map the task's referenceId to the list
      // of available volunteers' referenceId
      tasksVolunteersMap[task.referenceId] =
      availableVolunteers.map((volunteer) => volunteer.referenceId);
    }

    return task;
  });

  // Filter out tasks with no assigned volunteers
  availableTasks = availableTasks.filter((task) => task.assignedto);

  console.log("Returning tasks and volunteers map:",
      {tasks: availableTasks, volunteers: tasksVolunteersMap});

  // Send back the tasks with assigned
  // volunteers and the tasksVolunteersMap to the client
  res.json({tasks: availableTasks, volunteers: tasksVolunteersMap});
});
