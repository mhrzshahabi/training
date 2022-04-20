package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ForeignLangKnowledgeDTO;
import com.nicico.training.model.ForeignLangKnowledge;

import java.util.List;

public interface IForeignLangKnowledgeService {

    ForeignLangKnowledgeDTO.Info get(Long id);

    ForeignLangKnowledge getForeignLangKnowledge(Long id);

    ForeignLangKnowledgeDTO.Info update(Long id, ForeignLangKnowledgeDTO.Update request);

    SearchDTO.SearchRs<ForeignLangKnowledgeDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    void addForeignLangKnowledge(ForeignLangKnowledgeDTO.Create request, Long teacherId);

    void deleteForeignLangKnowledge(Long teacherId, Long foreignLangKnowledgeId);

    List<ForeignLangKnowledgeDTO.Resume> getListByTeacherId(String nationalCode);

}
