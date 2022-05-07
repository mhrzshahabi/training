package com.nicico.training.controller;

import com.nicico.training.controller.client.minio.MinIoClient;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api/minIo")
@RequiredArgsConstructor
public class MinIoRestController {

    private final MinIoClient client;

    @GetMapping("/downloadFile/{groupId}/{key}/{fileName}")
    public ResponseEntity<ByteArrayResource> downloadFile(HttpServletRequest request, @PathVariable String groupId, @PathVariable String key, @PathVariable String fileName) {

        ByteArrayResource file = client.downloadFile(request.getHeader("Authorization"), "Training", groupId, key);
        try {
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .body(file);
        } catch ( Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @GetMapping("/downloadFile-by-key/{groupId}/{key}")
    public ResponseEntity<ByteArrayResource> downloadFileByKey(HttpServletRequest request, @PathVariable String groupId, @PathVariable String key) {

        ByteArrayResource file = client.downloadFile(request.getHeader("Authorization"), "Training", groupId, key);
        try {
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"")
                    .body(file);
        } catch ( Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
