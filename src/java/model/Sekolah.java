package model;

public class Sekolah extends User {
    
    // Constructor default, panggil constructor superclass
    public Sekolah(){
        super();
    }
    
    // Constructor untuk insert baru (tanpa idUser), role user otomatis "SEKOLAH"
    public Sekolah(String nama, String username, String email, String password, String alamat, String nomorTelepon, String imageUrl, String tipeRekening, String nomorRekening) {
        super(nama, username, email, password, alamat, nomorTelepon, "SEKOLAH", imageUrl, tipeRekening, nomorRekening);
    }

    // Constructor lengkap dengan idUser, role user otomatis "SEKOLAH"
    public Sekolah(int idUser, String nama, String username, String email, String password, String alamat, String nomorTelepon, String imageUrl, String tipeRekening, String nomorRekening) {
        super(idUser, nama, username, email, password, alamat, nomorTelepon, "SEKOLAH", imageUrl, tipeRekening, nomorRekening);
    }
}