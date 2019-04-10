unit wstFileDataSys;

interface 
    uses wstCore, wstBook, wstUser, wstBorrowHist, wstReturnHist, wstLostReport;
    procedure wstBookStockProc(var bl : BookList; bhl : BorrowHistList; lrl : LostReportList);
    { F13 - Load File }
    procedure wstLoadFile(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Membaca input nama-nama file kemudian memuat data perpustakaan dari
            file-file terseubut. }
        { I.S. Semua parameter terdeklarasi. }
        { F.S. Data perpustakaan dimuat di list data. }
    { F14 - Save File }
    procedure wstSaveFile(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Membaca input nama-nama file kemudian menyimpan data perpustakaan ke
            file-file terseubut. }
        { I.S. Semua parameter terdeklarasi, parameter list terdefinisi. }
        { F.S. Data perpustakaan disimpan. }
    { F15 - Pencarian Anggota }
    procedure wstSearchMember(ul : UserList);
        { SPESIFIKASI : Menerima input username dari user, kemudian mencari anggota dari UserList ul
            dengan username tersebut dan menampilkan nama dan alamat user jika ada atau menampilkan
            pesan jika tidak ada. }
        { I.S. ul terdefinisi. }
        { F.S. Nama dan alamat anggota, atau pesan tidak ada anggota ditammpilkan di layar. }
    { F16 - Exit }
    procedure wstExit(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Keluar dari program. (ada opsi untuk menyimpan file)}
        { I.S. Program berjalan, semua parameter terdefinisi. }
        { F.S. Program selesai, data perpustakaan disimpan jika input Y. }

implementation
    procedure wstBookStockProc(var bl : BookList; bhl : BorrowHistList; lrl : LostReportList);
        var
            i, j : integer;
        begin
            for i := 1 to bl.Neff do begin
                bl.t[i]._stock := bl.t[i]._qty;
                for j := 1 to bhl.Neff do begin
                    if (bl.t[i]._id = bhl.t[j]._id) and (bhl.t[j]._status = 'belum') then begin
                        bl.t[i]._stock -= 1;
                    end;
                end;
                for j := 1 to lrl.Neff do begin
                    if (bl.t[i]._id = lrl.t[j]._id) then begin
                        bl.t[i]._stock -= 1;
                    end;
                end;
            end;
        end;

    { F13 - Load File }
    procedure wstLoadFile(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Membaca input nama-nama file kemudian memuat data perpustakaan dari
            file-file terseubut. }
        { I.S. Semua parameter terdeklarasi. }
        { F.S. Data perpustakaan dimuat di list data. }
        { KAMUS LOKAL }
        var
            sb, su, sbh, srh, slr : string;
        { ALGORITMA }
        begin
            { Menerima nama file }
            write('<o> Masukkan nama File Buku: ');
            readln(sb);
            write('<o> Masukkan nama File User: ');
            readln(su);
            write('<o> Masukkan nama File Peminjaman: ');
            readln(sbh);
            write('<o> Masukkan nama File Pengembalian: ');
            readln(srh);
            write('<o> Masukkan nama File Buku Hilang: ');
            readln(slr);
            { Membaca isi file dan memuat data ke list }
            assign(fb, sb);
            reset(fb);
            BookLoadListFromCSV(fb, bl);
            close(fb);
            assign(fu, su);
            reset(fu);
            UserLoadListFromCSV(fu, ul);
            close(fu);
            assign(fbh, sbh);
            reset(fbh);
            BorrowHistLoadListFromCSV(fbh, bhl);
            close(fbh);
            assign(frh, srh);
            reset(frh);
            ReturnHistLoadListFromCSV(frh, rhl);
            close(frh);
            assign(flr, slr);
            reset(flr);
            LostReportLoadListFromCSV(flr, lrl);
            close(flr);
            wstBookStockProc(bl, bhl, lrl);
            writeln('[i] File perpustakaan berhasil dimuat!')
        end;

    { F14 - Save File }
    procedure wstSaveFile(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Membaca input nama-nama file kemudian menyimpan data perpustakaan ke
            file-file terseubut. }
        { I.S. Semua parameter terdeklarasi, parameter list terdefinisi. }
        { F.S. Data perpustakaan disimpan. }
        { KAMUS LOKAL }
        var
            sb, su, sbh, srh, slr : string;
        { ALGORITMA }
        begin
            { Menerima nama file }
            write('<o> Masukkan nama File Buku: ');
            readln(sb);
            write('<o> Masukkan nama File User: ');
            readln(su);
            write('<o> Masukkan nama File Peminjaman: ');
            readln(sbh);
            write('<o> Masukkan nama File Pengembalian: ');
            readln(srh);
            write('<o> Masukkan nama File Buku Hilang: ');
            readln(slr);
            { Membaca isi file dan memuat data ke list }
            assign(fb, sb);
            rewrite(fb);
            BookSaveListToCSV(fb, bl);
            close(fb);
            assign(fu, su);
            rewrite(fu);
            UserSaveListToCSV(fu, ul);
            close(fu);
            assign(fbh, sbh);
            rewrite(fbh);
            BorrowHistSaveListToCSV(fbh, bhl);
            close(fbh);
            assign(frh, srh);
            rewrite(frh);
            ReturnHistSaveListToCSV(frh, rhl);
            close(frh);
            assign(flr, slr);
            rewrite(flr);
            LostReportSaveListToCSV(flr, lrl);
            close(flr);
            writeln('[i] Data berhasil disimpan!')
        end;

    { F15 - Pencarian Anggota }
    procedure wstSearchMember(ul : UserList);
        { SPESIFIKASI : Menerima input username dari user, kemudian mencari anggota dari UserList ul
            dengan username tersebut dan menampilkan nama dan alamat user jika ada atau menampilkan
            pesan jika tidak ada. }
        { I.S. ul terdefinisi. }
        { F.S. Nama dan alamat anggota, atau pesan tidak ada anggota ditammpilkan di layar. }
        { KAMUS LOKAL }
        var
            i : integer;
            uname : string;
        begin
        { ALGORITMA }
            write('<o> Masukkan username: ');
            readln(uname);
            i := 1;
            while (uname <> ul.t[i]._username) and (i < ul.Neff) do begin
                i += 1;
            end;
            if (uname = ul.t[i]._username) then begin
                writeln('[o] Nama Anggota: ', ul.t[i]._fullname);
                writeln('[o] Alamat Anggota: ', ul.t[i]._address);
            end else begin { uname <> bl.t[i]._username }
                writeln('[o] Tidak ada anggota dengan username ', uname);
            end;
        end;

    { F16 - Exit }
    procedure wstExit(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Keluar dari program. (ada opsi untuk menyimpan file)}
        { I.S. Program berjalan, semua parameter terdefinisi. }
        { F.S. Program selesai, data perpustakaan disimpan jika input Y. }
        { KAMUS LOKAL }
        var
            s : string;
        { ALGORITMA }
        begin
            { Menerima input secara terus-menerus sampai input Y atau N}
            repeat
                write('<o> Simpan file? (Y/N): ');
                readln(s);
            until (s = 'Y') or (s = 'N');
            if (s = 'Y') then begin
                wstSaveFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
            end; {else do nothing}
        end;

end.