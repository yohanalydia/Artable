package model;

public class Admin extends User{
    
    // Constructor untuk admin yang akan langsung memasukan nilai default "ADMIN" sebagai role
    public Admin(String nama, String username, String email, String password, String nomorTelepon) {
        super(nama, username, email, password, "", nomorTelepon, "ADMIN", "", "", "");
    }
    
    // Constructor untuk admin yang akan langsung memasukan nilai default "ADMIN" sebagai role dengan idUser yang telah terdefinisi
    public Admin(int idUser, String nama, String username, String email, String password, String nomorTelepon) {
        super(idUser, nama, username, email, password, "", nomorTelepon, "ADMIN", "", "", "");
    }
}
