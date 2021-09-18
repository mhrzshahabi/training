package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:roya
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassDocumentDTO;
import com.nicico.training.model.ClassDocument;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;

public interface IClassDocumentService {

    @Transactional(readOnly = true)
    SearchDTO.SearchRs<ClassDocumentDTO.Info> search(SearchDTO.SearchRq request);

    @Transactional
    ClassDocumentDTO.Info create(ClassDocumentDTO.Create request, HttpServletResponse response);

    @Transactional
    ClassDocumentDTO.Info update(Long id, ClassDocumentDTO.Update request, HttpServletResponse response);

    @Transactional(readOnly = true)
    ClassDocument getClassDocument(Long id);

    @Transactional
    void delete(Long id);

    @Transactional
    Boolean checkLetterNum(Long classId, String letterNum);
}
