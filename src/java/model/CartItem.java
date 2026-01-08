package model;
import java.sql.ResultSet;

public class CartItem extends Model<CartItem>{
    private int idCartItem;
    private int idCart;
    private int idProduk;
    private int quantity = 0;
    
    public CartItem(){
        this.table = "cartitem";
        this.primaryKey = "idCartItem";
    }
    
    @Override
    CartItem toModel(ResultSet rs) {
        try {
            CartItem ci = new CartItem(rs.getInt("idCartItem"), rs.getInt("idCart"), rs.getInt("idProduk"), rs.getInt("quantity"));
            return ci;
        } catch (Exception e) {
            System.out.println("Error toModel CartItem: " + e.getMessage());
            return null;
        }
    }

    public CartItem(int idCartItem, int idCart, int idProduk, int quantity) {
        this();
        this.idCartItem = idCartItem;
        this.idCart = idCart;
        this.idProduk = idProduk;
        this.quantity = quantity;
    }
    

    public int getIdCartItem() {
        return idCartItem;
    }

    public void setIdCartItem(int idCartItem) {
        this.idCartItem = idCartItem;
    }
    
    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public void addQuantity(){
            this.quantity++;
    }

    public int getIdProduk() {
        return idProduk;
    }

    public void setIdProduk(int idProduk) {
        this.idProduk = idProduk;
    }

    public int getIdCart() {
        return idCart;
    }

    public void setIdCart(int idCart) {
        this.idCart = idCart;
    }
    
    
}
