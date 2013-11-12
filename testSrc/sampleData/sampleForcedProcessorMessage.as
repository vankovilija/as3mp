/**
 * sampleForcedProcessorMessage
 * @author Ilija Vankov
 */
package sampleData {

public const sampleForcedProcessorMessage:Object = {
    status_code: 200,
    message_id: 1,
    user: {
        facebook_id: 1000,
        name: "Jon Doe",
        dob: "1986-02-03"
    },
    friends: [
        {
            facebook_id: 1000,
            name: "Van Halen",
            dob: "1972-01-15",
            isAppUser: 0
        },
        {
            facebook_id: 1001,
            name: "Offspring",
            dob: "1984-09-03",
            isAppUser: 0
        },
        {
            facebook_id: 1002,
            name: "Puddle of Mudd",
            dob: "1991-06-11",
            isAppUser: 1,
            score: 100
        },
        {
            facebook_id: 1001,
            name: "Metallica",
            dob: "1981-06-05",
            isAppUser: 0
        },
        {
            facebook_id: 1001,
            name: "Iron Maiden",
            dob: "1975-05-10",
            isAppUser: 1,
            score: 130
        }
    ],
    inventoryItems: [
        {
            itemID: 1,
            name: "Knife",
            description: "stab enemies",
            attackPower: 200,
            type: "physical"
        },
        {
            itemID: 2,
            name: "Meteor",
            description: "burn your enemies!",
            attackPower: 250,
            type: "magical",
            range: 200
        },
        {
            itemID: 3,
            name: "Shield",
            description: "getting hit hurts, protect yourself!",
            defenceAmount: 100,
            type: "physical"
        },
        {
            itemID: 4,
            name: "Magic Barrier",
            description: "don't let yourself get burned!",
            defenceAmount: 90,
            type: "magical"
        },
        {
            itemID: 5,
            name: "Arrow",
            description: "Hit your enemies from a far!",
            attackPower: 190,
            type: "physical",
            range: 200
        },
        {
            itemID: 6,
            name: "Healing Spell",
            description: "Heal your friends, even if they are far away!",
            healAmount: 100,
            range: 200
        },
        {
            itemID: 6,
            name: "Healing Touch",
            description: "Only heal from close range",
            healAmount: 100
        }
    ]
};
}
