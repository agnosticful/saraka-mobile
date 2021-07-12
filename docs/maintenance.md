# Maintenance Mode

## How to opt in to maintenance mode

There's 2 things we need to do.

- Change Firestore security rules so that it deny any operations except for a `maintenances` collection
- Create a document in `maintenances` collection in Firestore

### Firestore security rules

Delete all permittion to do operation for any collections (except for `maintenances` collection).

```
service cloud.firestore {
	match /databases/{database}/documents {
		match /maintenances/{maintenanceId} {
			allow list, get: if true;
		}
	}
}
```

When the maintenance ends, restore the firestore security rules.

### `maintenance` document

Add a new document to `maintenances` collection with the following field.

- `isProcessing`: `true`
- `startedAt`: `April 10, 2019 at 12:00:00 AM UTC-7` (the date and time to start maintenance)
- `endedAt`: `April 10, 2019 at 12:30:00 AM UTC-7` (the date and time to end it)

**WARNING**: Once you set `isProcessing` to be `true`, it immediately reflects so that it's under maintenance for all users.

When the maintenance ends, set `isProcessing` to be `false`.
