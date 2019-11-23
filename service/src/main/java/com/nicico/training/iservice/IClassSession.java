package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;

import java.util.List;

public interface IClassSession {

  ClassSessionDTO.Info get(Long id);

   List<ClassSessionDTO.Info> list();

   ClassSessionDTO.Info create(ClassSessionDTO.ManualSession request);

   ClassSessionDTO.Info update(Long id, ClassSessionDTO.Update request);

   void delete(Long id);

   void delete(ClassSessionDTO.Delete request);

   SearchDTO.SearchRs<ClassSessionDTO.Info> search(SearchDTO.SearchRq request);

   void generateSessions (Long classId, TclassDTO.Create autoSessionsRequirement);

}
