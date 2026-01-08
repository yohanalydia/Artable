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
//            c.fetchItems();
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
    
//    public void fetchItems() {
//        CartItem ci = new CartItem();
//        ci.where("idCart = '" + this.idCart + "'");
//        this.daftarProduk = ci.get();
//    }
//
//    public double getTotal() {
//        double total = 0;
//        for (CartItem p : daftarProduk) {
//            total += p.hitungTotal();
//        }
//        return total;
//    }

//    public void clearCart() {
//        // Hapus dari database satu per satu menggunakan method delete() bawaan Model
//        for (int i = daftarProduk.size() - 1; i >= 0; i--) {
//            CartItem item = daftarProduk.get(i);
//            item.delete(); // Ini akan menghapus baris di tabel cart_item
//            daftarProduk.remove(i); // Ini menghapus dari list di Java
//        }
//    }

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
