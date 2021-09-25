package com.nicico.training.iservice;

import com.nicico.training.dto.SysUserInfoModel;

public interface IMinioService {

    SysUserInfoModel validateToken(String token);
}
