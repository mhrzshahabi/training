package com.nicico.training.service;

import com.nicico.training.dto.SysUserInfoModel;
import com.nicico.training.iservice.IMinioService;
import org.springframework.stereotype.Service;

@Service
public class MinioService implements IMinioService {




    @Override
    public SysUserInfoModel validateToken(String token) {
        return null;
    }
}
