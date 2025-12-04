/* Essentials Shop
 * Custom buy-only shop for essential items
 */

var status = -1;
var selectedItem = -1;

// Define your items here: [itemId, price, quantity]
var items = [
    [2000001, 500, 100],    // Red Potion - 500 mesos - 100 qty
    [2000002, 600, 100],    // Orange Potion - 600 mesos - 100 qty
    [2000003, 800, 100],    // White Potion - 800 mesos - 100 qty
    [2000004, 1000, 100],   // Blue Potion - 1000 mesos - 100 qty
    [2022179, 1500, 1],     // Elixir - 1500 mesos - 1 qty
    [2022265, 3000, 1],     // Full Elixir - 3000 mesos - 1 qty
    [2050004, 1000, 1],     // All Cure Potion - 1000 mesos - 1 qty
    [2060000, 500, 1000],   // Arrow for Bow - 500 mesos - 1000 qty
    [2061000, 500, 1000],   // Arrow for Crossbow - 500 mesos - 1000 qty
    [4006000, 100, 1],      // Magic Rock - 100 mesos - 1 qty
    [4006001, 150, 1]       // Summon Rock - 150 mesos - 1 qty
];

function start() {
    status = -1;
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1) {
        cm.dispose();
        return;
    }

    if (mode == 0) {
        if (status == 0) {
            cm.dispose();
            return;
        } else if (status == 1) {
            // Go back to item list
            status = -1;
            action(1, 0, 0);
            return;
        }
    }

    if (mode == 1) {
        status++;
    } else {
        status--;
    }

    if (status == 0) {
        var text = "Welcome to the #bEssentials Shop#k!\r\n\r\n";
        text += "Select an item you would like to purchase:\r\n\r\n";

        for (var i = 0; i < items.length; i++) {
            var itemId = items[i][0];
            var price = items[i][1];
            var quantity = items[i][2];

            text += "#L" + i + "##v" + itemId + "# #b#t" + itemId + "##k";
            text += " - #r" + addCommas(price) + " mesos#k";
            text += " (x" + quantity + ")#l\r\n";
        }

        cm.sendSimple(text);

    } else if (status == 1) {
        // Store selected item
        selectedItem = selection;

        if (selectedItem < 0 || selectedItem >= items.length) {
            cm.dispose();
            return;
        }

        var itemId = items[selectedItem][0];
        var price = items[selectedItem][1];
        var quantity = items[selectedItem][2];

        var text = "Are you sure you want to buy:\r\n\r\n";
        text += "#v" + itemId + "# #b#t" + itemId + "##k x" + quantity + "\r\n\r\n";
        text += "Price: #r" + addCommas(price) + " mesos#k\r\n\r\n";
        text += "#bDo you want to proceed with this purchase?#k";

        cm.sendYesNo(text);

    } else if (status == 2) {
        // Process purchase
        var itemId = items[selectedItem][0];
        var price = items[selectedItem][1];
        var quantity = items[selectedItem][2];

        // Check if player has enough mesos
        if (cm.getMeso() < price) {
            cm.sendOk("You don't have enough #rmesos#k to purchase this item.\r\n\r\nRequired: #r" + addCommas(price) + " mesos#k\r\nYou have: #b" + addCommas(cm.getMeso()) + " mesos#k");
            cm.dispose();
            return;
        }

        // Check if player has inventory space
        if (!cm.canHold(itemId, quantity)) {
            cm.sendOk("Please make sure you have enough #binventory space#k before purchasing this item.");
            cm.dispose();
            return;
        }

        // Give item and take mesos
        cm.gainItem(itemId, quantity);
        cm.gainMeso(-price);

        cm.sendOk("You have successfully purchased:\r\n\r\n#v" + itemId + "# #b#t" + itemId + "##k x" + quantity + "\r\n\r\nThank you for your purchase!");
        cm.dispose();
    }
}

// Helper function to format numbers with commas
function addCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}