package client.command.commands.gm2;

import client.Client;
import client.command.Command;
import server.ShopFactory;

public class MiuShopCommand extends Command {
    {
        setDescription("Open the Mui shop");
    }

    @Override
    public void execute(Client client, String[] params) {
        //Should be if have muiShopItem
        ShopFactory.getInstance().getShop(5450000).sendShop(client);
    }
}
