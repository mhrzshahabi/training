package com.nicico.training.iservice;

import com.nicico.training.dto.ClassSessionDTO;

import java.util.List;

public interface IClassSession {

   List<ClassSessionDTO.GeneratedSessions> generateSessions (ClassSessionDTO.AutoSessionsRequirement autoSessionsRequirement);

}
