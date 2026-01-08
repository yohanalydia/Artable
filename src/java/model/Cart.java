package model;

import java.sql.ResultSet;

public class Cart extends Model<Cart> {

    private int idCart;
    private int idUser;

    // Constructor default, set nama tabel dan primary key
    public Cart() {
        this.table = "cart";
        this.primaryKey = "idCart";
    }

    // Convert ResultSet jadi object Cart
    @Override
    Cart toModel(ResultSet rs) {
        try {
            Cart c = new Cart(rs.getInt("idCart"), rs.getInt("idUser"));
            return c;
        } catch (Exception e) {
            setMessage(e.getMessage());
            return null;
        }
    }

    // Constructor dengan parameter idCart dan idUser
    public Cart(int idCart, int idUser) {
        this.idUser = idUser;
        this.idCart = idCart;
    }

    // SETTER DAN GETTER
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
