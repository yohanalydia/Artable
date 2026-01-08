package model;

public class Sekolah extends User {
    
    public Sekolah(){
        super();
    }
    
    public Sekolah(String nama, String username, String email, String password, String alamat, String nomorTelepon, String role, String imageUrl, String tipeRekening, String nomorRekening) {
        super(nama, username, email, password, alamat, nomorTelepon, role, imageUrl, tipeRekening, nomorRekening);
    }

    public Sekolah(int idUser, String nama, String username, String email, String password, String alamat, String nomorTelepon, String role, String imageUrl, String tipeRekening, String nomorRekening) {
        super(idUser, nama, username, email, password, alamat, nomorTelepon, role, imageUrl, tipeRekening, nomorRekening);
    }
}