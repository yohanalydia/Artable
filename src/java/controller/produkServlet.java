package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.Produk;
import model.Seniman;
import model.User;

@WebServlet(name = "produkServlet", urlPatterns = {"/Produk"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class produkServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Produk p = new Produk();
        String menu = request.getParameter("menu");

        if ("myproduct".equals(menu)) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("Auth");
                return;
            }

            try {
                // 1. Ambil Semua Seniman milik sekolah ini untuk isi Dropdown di Form
                model.Seniman sModel = new model.Seniman();
                sModel.where("idUser = " + user.getIdUser());
                ArrayList<model.Seniman> listSeniman = sModel.get();
                request.setAttribute("listSeniman", listSeniman);

                // 2. Ambil Semua Produk yang dibuat oleh seniman-seniman dari sekolah ini
                // gunakan JOIN agar bisa memfilter produk berdasarkan idUser melalui tabel seniman
                Produk pModel = new Produk();
                pModel.join("seniman", "produk.idSeniman = seniman.idSeniman");
                pModel.where("seniman.idUser = " + user.getIdUser());
                ArrayList<Produk> listProduk = pModel.get();

                request.setAttribute("myProductList", listProduk);
                request.getRequestDispatcher("views/produkSaya.jsp").forward(request, response);
            } catch (Exception e) {
                // Cetak detail error di console NetBeans
                System.err.println("Error saat memuat produk saya: " + e.getMessage());
                e.printStackTrace();

                // Redirect dengan pesan error yang informatif
                response.sendRedirect("Home?error=failed_to_load_myproduct");
            }

        } else if ("shop".equals(menu)) {
            try {
                request.setAttribute("title", "ARTABLE SHOP");

                String category = request.getParameter("category");
                String sort = request.getParameter("sort");
                String search = request.getParameter("search");
                String searchSchool = request.getParameter("search-school");

                // Tambahkan Filter Kategori
                if (category != null && !category.isEmpty()) {
                    p.where("kategori = '" + category + "'");
                }

                // Tambahkan Sorting
                if ("price_low".equals(sort)) {
                    p.addQuery("ORDER BY harga ASC");
                } else if ("price_high".equals(sort)) {
                    p.addQuery("ORDER BY harga DESC");
                } else if ("newest".equals(sort)) {
                    p.addQuery("ORDER BY uploadTime DESC");
                }

                // Filter Pencarian Nama Sekolah
                if (searchSchool != null && !searchSchool.isEmpty()) {
                    // Hubungkan tabel: Produk -> Seniman -> User (Sekolah)
                    p.join("seniman", "produk.idSeniman = seniman.idSeniman");
                    p.join("user", "seniman.idUser = user.idUser");
                    if (category != null && !category.isEmpty()) {
                        p.where("kategori = '" + category + "' AND user.nama LIKE '%" + searchSchool + "%' AND user.role = 'SEKOLAH'");
                    } else {
                        p.where("user.nama LIKE '%" + searchSchool + "%' AND user.role = 'SEKOLAH'");
                    }
                }

                // Filter Pencarian Nama
                if (search != null && !search.isEmpty()) {
                    String searchCondition = "nama LIKE '%" + search + "%'";
                    if (category != null && !category.isEmpty()) {
                        p.where("kategori = '" + category + "' AND " + searchCondition);
                    } else {
                        p.where(searchCondition);
                    }
                }

                ArrayList<Produk> prods = p.get();

                request.setAttribute("list", prods);
                request.getRequestDispatcher("views/shop.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("Error pada Fitur Shop: " + e.getMessage());
                e.printStackTrace();

                // Jika error, kirim list kosong agar halaman tidak pecah dan beri pesan error
                request.setAttribute("list", new ArrayList<Produk>());
                request.setAttribute("errorMessage", "Gagal memuat katalog produk.");
                request.getRequestDispatcher("views/shop.jsp").forward(request, response);
            }

        } else if ("view".equals(menu)) {
            try {
                String id = request.getParameter("id");
                if (id != null) {
                    Produk pModel = new Produk();
                    // mencari 1 baris data berdasarkan ID
                    Produk detail = pModel.find("idProduk", id);

                    if (detail != null) {
                        request.setAttribute("p", detail);
                        request.getRequestDispatcher("views/detailProduk.jsp").forward(request, response);
                    } else {
                        // Jika ID tidak ditemukan di database
                        response.sendRedirect("Produk?menu=shop&msg=ProductNotFound");
                    }
                } else {
                    // Jika parameter ID tidak ada di URL
                    response.sendRedirect("Produk?menu=shop");
                }
            } catch (Exception e) {
                // Log error untuk kebutuhan debugging
                System.err.println("Error saat menampilkan detail produk: " + e.getMessage());
                e.printStackTrace();

                // Redirect ke katalog dengan pesan error
                response.sendRedirect("Produk?menu=shop&error=system_error");
            }
        } else if ("myseniman".equals(menu)) {
            try {
                User user = (User) request.getSession().getAttribute("user");

                // Proteksi jika session user tiba-tiba hilang
                if (user == null) {
                    response.sendRedirect("Auth");
                    return;
                }

                Seniman sModel = new Seniman();

                // Filter berdasarkan idUser (Sekolah yang login)
                sModel.where("idUser = " + user.getIdUser());
                ArrayList<Seniman> list = sModel.get();

                request.setAttribute("myArtistList", list);
                request.getRequestDispatcher("views/senimanSaya.jsp").forward(request, response);

            } catch (Exception e) {
                // Log error di console server
                System.err.println("Error saat memuat daftar seniman: " + e.getMessage());
                e.printStackTrace();

                // Redirect dengan pesan error agar user tidak bingung
                response.sendRedirect("Home?error=failed_to_load_artists");
            }
        } else if ("edit".equals(menu)) {
            try {
                // 1. Ambil ID produk dari URL
                String id = request.getParameter("id");

                if (id != null && !id.isEmpty()) {
                    // 2. Cari data produk berdasarkan ID tersebut
                    p = p.find("idProduk", id);

                    // Jika produk tidak ditemukan, jangan lanjut ke form edit
                    if (p == null) {
                        response.sendRedirect("Produk?menu=myproduct&error=ProductNotFound");
                        return;
                    }

                    // 3. Ambil session user untuk filter seniman
                    HttpSession session = request.getSession();
                    User user = (User) session.getAttribute("user");

                    if (user == null) {
                        response.sendRedirect("Auth");
                        return;
                    }

                    // Ambil daftar seniman milik sekolah ini untuk dropdown
                    Seniman s = new Seniman();
                    s.where("idUser = " + user.getIdUser());
                    ArrayList<Seniman> listSeniman = s.get();

                    // 4. Titipkan data ke Request
                    request.setAttribute("p", p);
                    request.setAttribute("listSeniman", listSeniman);

                    // 5. Lempar ke halaman editProduk.jsp
                    request.getRequestDispatcher("views/editProduk.jsp").forward(request, response);
                } else {
                    response.sendRedirect("Produk?menu=myproduct");
                }
            } catch (Exception e) {
                // Log error untuk debugging
                System.err.println("Error pada menu edit produk: " + e.getMessage());
                e.printStackTrace();

                // Redirect dengan pesan error
                response.sendRedirect("Produk?menu=myproduct&error=failed_to_load_edit_form");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if ("insert".equals(action)) {
            try {
                // 1. Tangkap data teks (termasuk idSeniman dari dropdown)
                String nama = request.getParameter("nama");
                String kategori = request.getParameter("kategori");
                String deskripsi = request.getParameter("deskripsi");
                double harga = Double.parseDouble(request.getParameter("harga"));
                int stok = Integer.parseInt(request.getParameter("stok"));
                double berat = Double.parseDouble(request.getParameter("berat").replace(',', '.'));
                String dimensi = request.getParameter("dimensi");
                String material = request.getParameter("material");
                int idSeniman = Integer.parseInt(request.getParameter("idSeniman")); // TANGKAP ID SENIMAN

                // 2. Proses Gambar (Tetap sama seperti sebelumnya)
                Part filePart = request.getPart("foto");
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/") + "assets/fotoProduk";
                filePart.write(uploadPath + java.io.File.separator + fileName);
                String imageUrl = "assets/fotoProduk/" + fileName;

                // 3. Simpan ke Database
                Produk baru = new Produk();
                baru.setNama(nama);
                baru.setKategori(kategori);
                baru.setDeskripsi(deskripsi);
                baru.setHarga(harga);
                baru.setStok(stok);
                baru.setBerat(berat);
                baru.setDimensi(dimensi);
                baru.setMaterial(material);
                baru.setImageUrl(imageUrl);
                baru.setIdSeniman(idSeniman); // MASUKKAN ID SENIMAN KE PRODUK

                baru.insert();

                response.sendRedirect("Produk?menu=myproduct&msg=Berhasil Posting Karya");

            } catch (Exception e) {
                e.printStackTrace();
                // Gunakan URLEncoder agar pesan error aman dikirim lewat URL
                String errorMessage = java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
                response.sendRedirect("Produk?menu=myproduct&error=" + errorMessage);
            }
        } else if ("delete".equals(action)) {
            try {
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    int idProduk = Integer.parseInt(idParam);
                    Produk p = new Produk();
                    p.setIdProduk(idProduk);

                    // Eksekusi hapus
                    p.delete();

                    response.sendRedirect("Produk?menu=myproduct&msg=Berhasil Hapus Karya");
                } else {
                    response.sendRedirect("Produk?menu=myproduct");
                }
            } catch (Exception e) {
                // Log error untuk developer
                System.err.println("Gagal hapus produk: " + e.getMessage());
                e.printStackTrace();

                // Kirim pesan error ke user
                response.sendRedirect("Produk?menu=myproduct&error=Gagal hapus karya. Karya ini tidak bisa dihapus karena sudah memiliki riwayat transaksi.");
            }
        } else if ("update".equals(action)) {
            try {
                // 1. Ambil data teks (termasuk ID produk yang mau diedit)
                int id = Integer.parseInt(request.getParameter("id"));
                String nama = request.getParameter("nama");
                String kategori = request.getParameter("kategori");
                String deskripsi = request.getParameter("deskripsi");
                double harga = Double.parseDouble(request.getParameter("harga"));
                int stok = Integer.parseInt(request.getParameter("stok"));
                double berat = Double.parseDouble(request.getParameter("berat").replace(',', '.'));
                String dimensi = request.getParameter("dimensi");
                String material = request.getParameter("material");
                int idSeniman = Integer.parseInt(request.getParameter("idSeniman"));

                // Cari data lama untuk mendapatkan URL gambar yang sekarang
                Produk produkLama = new Produk().find("idProduk", String.valueOf(id));
                String imageUrl = produkLama.getImageUrl(); // Default: gunakan gambar lama

                // 2. Proses Gambar (Hanya jika ada file baru yang diupload)
                Part filePart = request.getPart("foto");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    String uploadPath = getServletContext().getRealPath("/") + "assets/fotoProduk";

                    // Buat folder jika belum ada
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    filePart.write(uploadPath + java.io.File.separator + fileName);
                    imageUrl = "assets/fotoProduk/" + fileName; // Update URL ke gambar baru
                }

                // 3. Update ke Database
                Produk p = new Produk();
                p.setIdProduk(id); // Set ID agar tahu data mana yang diupdate
                p.setNama(nama);
                p.setKategori(kategori);
                p.setDeskripsi(deskripsi);
                p.setHarga(harga);
                p.setStok(stok);
                p.setBerat(berat);
                p.setDimensi(dimensi);
                p.setMaterial(material);
                p.setImageUrl(imageUrl);
                p.setIdSeniman(idSeniman);

                p.update(); // Eksekusi update

                response.sendRedirect("Produk?menu=myproduct&msg=Berhasil Update Karya");

            } catch (Exception e) {
                e.printStackTrace();
                String errorMessage = java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
                response.sendRedirect("Produk?menu=myproduct&error=" + errorMessage);
            }

        } else if ("updateDeskripsi".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Produk p = new Produk().find("idProduk", String.valueOf(id));
                Seniman s = new Seniman().find("idSeniman", String.valueOf(p.getIdSeniman()));
                if (user != null && s != null && s.getIdUser() == user.getIdUser()) {
                    String deskripsiBaru = request.getParameter("deskripsi baru");
                    p.setDeskripsi(deskripsiBaru);
                    p.update();

                    response.sendRedirect("Produk?menu=view&id=" + id + "&msg=Deskripsi berhasil diperbarui");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("Produk?menu=shop&error=Gagal update deskripsi");
            }
        }
    }
}
