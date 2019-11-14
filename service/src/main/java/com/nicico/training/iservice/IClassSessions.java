package com.nicico.training.iservice;

import com.nicico.training.dto.ClassSessionsDTO;

import java.util.List;

public interface IClassSessions {

   List<ClassSessionsDTO.GeneratedSessions> generateSessions (ClassSessionsDTO.AutoSessionsRequirement autoSessionsRequirement);

}
