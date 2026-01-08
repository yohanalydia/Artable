package model;

public class Admin extends User{
    public Admin(String nama, String username, String email, String password, String nomorTelepon, String role) {
        super(nama, username, email, password, "", nomorTelepon, role, "", "", "");
    }

    public Admin(int idUser, String nama, String username, String email, String password, String nomorTelepon, String role) {
        super(idUser, nama, username, email, password, "", nomorTelepon, role, "", "", "");
    }
}
