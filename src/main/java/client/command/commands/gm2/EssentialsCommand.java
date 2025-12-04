package client.command.commands.gm2;

import client.Client;
import client.command.Command;
import server.ShopFactory;

public class EssentialsCommand extends Command {
    {
        setDescription("Open the Essentials shop/window.");
    }

    @Override
    public void execute(Client client, String[] params) {
        ShopFactory.getInstance().getShop(1335).sendShop(client);
    }
}
