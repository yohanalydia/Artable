package model;

import java.sql.ResultSet;

public class DetailTransaksi extends Model<DetailTransaksi> implements Updateable {

    private int idDetail;
    private int idTransaksi;
    private int idProduk;
    private int idSekolah; // ID Sekolah (User dengan role SEKOLAH)
    private int qty;
    private double hargaSatuan;
    private String buktiTransfer;
    private String status;
    private String noResi;
    private String kurir;
    
    // Constructor default, set nama tabel dan primary key
    public DetailTransaksi() {
        this.table = "detail_transaksi";
        this.primaryKey = "idDetail";
    }

    // Constructor tanpa idDetail (untuk insert baru)
    public DetailTransaksi(int idTransaksi, int idProduk, int idSekolah, int qty, double hargaSatuan, String buktiTransfer, String status, String noResi, String kurir) {
        this();
        this.idTransaksi = idTransaksi;
        this.idProduk = idProduk;
        this.idSekolah = idSekolah;
        this.qty = qty;
        this.hargaSatuan = hargaSatuan;
        this.buktiTransfer = buktiTransfer;
        this.status = status;
        this.noResi = noResi;
        this.kurir = kurir;
    }
    
    // Constructor lengkap dengan idDetail (untuk read/update)
    public DetailTransaksi(int idDetail, int idTransaksi, int idProduk, int idSekolah, int qty, double hargaSatuan, String buktiTransfer, String status, String noResi, String kurir) {
        this();
        this.idDetail = idDetail;
        this.idTransaksi = idTransaksi;
        this.idProduk = idProduk;
        this.idSekolah = idSekolah;
        this.qty = qty;
        this.hargaSatuan = hargaSatuan;
        this.buktiTransfer = buktiTransfer;
        this.status = status;
        this.noResi = noResi;
        this.kurir = kurir;
    }
    
    // Convert ResultSet jadi object DetailTransaksi
    @Override
    public DetailTransaksi toModel(ResultSet rs) {
        try {
            DetailTransaksi dt = new DetailTransaksi(
                    rs.getInt("idDetail"),
                    rs.getInt("idTransaksi"),
                    rs.getInt("idProduk"),
                    rs.getInt("idSekolah"),
                    rs.getInt("qty"),
                    rs.getDouble("hargaSatuan"),
                    rs.getString("buktiTransfer"),
                    rs.getString("status"),
                    rs.getString("noResi"),
                    rs.getString("kurir")
            );

            return dt;
        } catch (Exception e) {
            setMessage(e.getMessage());
            return null;
        }
    }

    // SETTER DAN GETTER
    public int getIdDetail() {
        return idDetail;
    }

    public void setIdDetail(int idDetail) {
        this.idDetail = idDetail;
    }

    public int getIdTransaksi() {
        return idTransaksi;
    }

    public void setIdTransaksi(int idTransaksi) {
        this.idTransaksi = idTransaksi;
    }

    public int getIdProduk() {
        return idProduk;
    }

    public void setIdProduk(int idProduk) {
        this.idProduk = idProduk;
    }

    public int getIdSekolah() {
        return idSekolah;
    }

    public void setIdSekolah(int idSekolah) {
        this.idSekolah = idSekolah;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public double getHargaSatuan() {
        return hargaSatuan;
    }

    public void setHargaSatuan(double hargaSatuan) {
        this.hargaSatuan = hargaSatuan;
    }

    public String getBuktiTransfer() {
        return buktiTransfer;
    }

    public void setBuktiTransfer(String buktiTransfer) {
        this.buktiTransfer = buktiTransfer;
    }

    public String getStatus() {
        return status;
    }
    
    @Override
    public void updateStatus(String status) {
        this.status = status;
    }

    public String getNoResi() {
        return noResi;
    }

    public void setNoResi(String noResi) {
        this.noResi = noResi;
    }

    public String getKurir() {
        return kurir;
    }

    public void setKurir(String kurir) {
        this.kurir = kurir;
    }
    
}
