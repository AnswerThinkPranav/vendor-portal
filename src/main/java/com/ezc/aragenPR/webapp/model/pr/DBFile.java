package com.ezc.aragenPR.webapp.model.pr;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "EZC_UPLOAD_FILES")
@Data
@NoArgsConstructor
public class DBFile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "EUF_REQ_ID")
    private String reqID;

    @Column(name = "EUF_FILENAME", length = 500)
    private String fileName;

    @Column(name = "EUF_FILETYPE", length = 20)
    private String fileType;

    @Column(name = "EUF_FILEPATH", length = 200)
    private String filePath;

    @Lob
    @Column(name = "EUF_DATA", length = 1000)
    private byte[] data;

    public DBFile(String fileName, String fileType, String filePath) {
        this.fileName = fileName;
        this.fileType = fileType;
        this.filePath = filePath;
    }
}