package model;

import java.sql.ResultSet;

public class Seniman extends Model<Seniman> {
    private int idSeniman;
    private String nama;
    private String tanggalLahir;
    private String jenisDisabilitas;
    private String jenisKelamin;
    private String tentangSaya;
    private String imageUrl;
    private int idUser;

    // Constructor default, set nama tabel dan primary key
    public Seniman() {
        this.table = "seniman";
        this.primaryKey = "idSeniman";
    }

    // Constructor untuk insert baru (tanpa idSeniman)
    public Seniman(String nama, String tanggalLahir, String jenisDisabilitas, String jenisKelamin, String tentangSaya, String imageUrl, int idUser) {
        this();
        this.nama = nama;
        this.tanggalLahir = tanggalLahir;
        this.jenisDisabilitas = jenisDisabilitas;
        this.jenisKelamin = jenisKelamin;
        this.tentangSaya = tentangSaya;
        this.imageUrl = imageUrl;
        this.idUser = idUser;
    }
    
    // Constructor lengkap dengan idSeniman (untuk read/update)
    public Seniman(int id, String nama, String tanggalLahir, String jenisDisabilitas, String jenisKelamin, String tentangSaya, String imageUrl, int idUser) {
        this();
        this.idSeniman = id;
        this.nama = nama;
        this.tanggalLahir = tanggalLahir;
        this.jenisDisabilitas = jenisDisabilitas;
        this.jenisKelamin = jenisKelamin;
        this.tentangSaya = tentangSaya;
        this.imageUrl = imageUrl;
        this.idUser = idUser;
    }

    // SETTER DAN GETTER
    public void setId(int idSeniman) {
        this.idSeniman = idSeniman;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public void setTanggalLahir(String tanggalLahir) {
        this.tanggalLahir = tanggalLahir;
    }

    public void setJenisDisabilitas(String jenisDisabilitas) {
        this.jenisDisabilitas = jenisDisabilitas;
    }

    public void setJenisKelamin(String jenisKelamin) {
        this.jenisKelamin = jenisKelamin;
    }

    public void setTentangSaya(String tentangSaya) {
        this.tentangSaya = tentangSaya;
    }

    public void setFotoProfil(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public int getIdSeniman() {
        return idSeniman;
    }

    public String getNama() {
        return nama;
    }

    public String getTanggalLahir() {
        return tanggalLahir;
    }

    public String getJenisDisabilitas() {
        return jenisDisabilitas;
    }

    public String getJenisKelamin() {
        return jenisKelamin;
    }

    public String getTentangSaya() {
        return tentangSaya;
    }

    public String getFotoProfil() {
        return imageUrl;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    // Convert ResultSet jadi object Seniman
    @Override
    Seniman toModel(ResultSet rs){
        try {
             // Ambil data dari ResultSet dan buat object Seniman
            return new Seniman(
                rs.getInt("idSeniman"), 
                rs.getString("nama"), 
                rs.getString("tanggalLahir"), 
                rs.getString("jenisDisabilitas"), 
                rs.getString("jenisKelamin"), 
                rs.getString("tentangSaya"), 
                rs.getString("imageUrl"), 
                rs.getInt("idUser")
            );
        } catch (Exception e){
            setMessage(e.getMessage());
        }
        return null;
    }
}
