package model;

public class Pembeli extends User{
    
    // Constructor untuk input user baru (id belum terbentuk)
    public Pembeli(String nama, String username, String email, String password, String alamat, String nomorTelepon, String role, String imageUrl) {
        super(nama, username, email, password, alamat, nomorTelepon, role, imageUrl, "", "");

    }
    
    // Constructor untuk data dari database (id telah terbentuk)
    public Pembeli(int idUser, String nama, String username, String email, String password, String alamat, String nomorTelepon, String role, String imageUrl) {
        super(idUser, nama, username, email, password, alamat, nomorTelepon, role, imageUrl, "", "");
    }
}