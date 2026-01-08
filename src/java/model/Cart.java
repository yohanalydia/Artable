package model;

import java.sql.ResultSet;

public class Cart extends Model<Cart> {
    private int idCart;
    private int idUser;

    public Cart() {
        this.table = "cart";
        this.primaryKey = "idCart";
    }

    @Override
    Cart toModel(ResultSet rs) {
        try {
            Cart c = new Cart(rs.getInt("idCart"), rs.getInt("idUser"));
            return c;
        } catch (Exception e) {
            return null;
        }
    }

    public Cart(int idCart, int idUser) {
        this.idUser = idUser;
        this.idCart = idCart;
    }

    public void setUserId(int idUser) {
        this.idUser = idUser;
    }

    public int getIdCart() {
        return idCart;
    }

    public void setIdCart(int idCart) {
        this.idCart = idCart;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

}
