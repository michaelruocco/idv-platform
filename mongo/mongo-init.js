db.createUser(
    {
        user: "idv",
        pwd: "welcome01",
        roles: [ { role: "readWrite", db: "idv-local" } ]
    }
);