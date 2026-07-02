package com.ezc.aragenPR.webapp.service.pr;

import com.ezc.aragenPR.webapp.model.pr.DBFile;
import com.ezc.aragenPR.webapp.repository.pr.DBFileRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class DBFileStorageService {

    @Autowired
    private DBFileRepo dbFileRepo;

    public DBFile storeFile(MultipartFile file) throws IOException {
        String fileName = file.getOriginalFilename();
        DBFile dbFile = new DBFile(fileName, file.getContentType(), "");
        dbFile.setData(file.getBytes());
        return dbFileRepo.save(dbFile);
    }

    public DBFile getFile(int fileId) {
        return dbFileRepo.findById(fileId).orElse(null);
    }
}