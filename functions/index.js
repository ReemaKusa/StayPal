const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors")({ origin: true });

admin.initializeApp();

exports.sendEmailVerificationLink = functions.https.onRequest((req, res) => {
    cors(req, res, async () => {
        const { email } = req.body;

        if (!email) {
            return res.status(400).send("Missing email");
        }

        try {
            const link = await admin.auth().generateEmailVerificationLink(email);
            return res.status(200).json({ link });
        } catch (err) {
            console.error("Error:", err);
            return res.status(500).send("Server error");
        }
    });
});