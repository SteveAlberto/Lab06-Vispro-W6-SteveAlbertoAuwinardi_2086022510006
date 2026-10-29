## Check Yourself

## 1. What is the difference between the Model, View, and ViewModel in this application?
- Model : digunakan hanya untuk menyimpan data perpustakaan, model tidak tau bagaimana tampilan flutter maupun logikanya.
- View : digunakan untuk menampilkan data ke layar pengguna atau antarmuka pengguna (UI) dan meneruskan data interaksi pengguna ke ViewModel.
- ViewModel : digunakan sebagai inti logika dan aturan aturan (seperti cara pinjam, syarat kembalikan buku, dan rumus hitung denda). Ketika ada data yang berubah, ViewModel akan langsung meminta bagian Tampilan supaya layarnya di refresh.

## 2. Why should the fine calculation not be placed inside LoanCard.build()?
Karena fungsi build() dipanggil berulang kali setiap kali layar menggambar ulang. Kalau rumus denda ditaruh di situ, aplikasi jadi boros memori dan kodenya jadi susah diuji karena di load berulang ulang.

## 3. What should happen if a student attempts to borrow a book that already has an active loan?
Sistem bakal otomatis menolak karena status buku tersebut sedang tidak tersedia (isAvailable == false). ViewModel lalu mengirim pesan error.

## 4. Why is it better to calculate the fine in one place rather than repeating the formula in multiple widgets?
Supaya kalau ada perubahan rumus, kita cukup mengubahnya di satu tempat saja dan terhindar dari risiko beda hitungan denda di layar yang berbeda.

## 5. What is the difference between a book being Overdue and being Missing?
Overdue artinya buku hanya terlambat biasa dan dendanya dihitung harian/mingguan. Sedangkan Missing artinya buku sudah terlambat lebih dari 6 bulan, jadi peminjamnya harus mengganti harga buku tersebut dan juga denda selama 6 bulan.

## 6. If the university changes its weekly fine from Rp5,000 to Rp7,000, how should the app be updated?
Cukup ubah satu angka variabel denda di bagian file ViewModel atau FinePolicy. Seluruh tampilan layar akan otomatis menyesuaikan denda tersebut tanpa perlu ada kode widget yang diubah.