package client.command.commands.gm2;

import client.Client;
import client.command.Command;
import constants.id.NpcId;

public class EssentialsCommand extends Command {
    {
        setDescription("Open the Essentials shop/window.");
    }

    @Override
    public void execute(Client client, String[] params) {
        // Create and open a custom essentials script
        // You'll need to create a script file called "essentials.js"
        client.getAbstractPlayerInteraction().openNpc(NpcId.MIU, "essentials");
    }
}