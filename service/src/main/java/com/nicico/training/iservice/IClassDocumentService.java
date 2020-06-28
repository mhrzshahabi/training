package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:roya
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassDocumentDTO;
import org.springframework.transaction.annotation.Transactional;

public interface IClassDocumentService {

    @Transactional(readOnly = true)
    SearchDTO.SearchRs<ClassDocumentDTO.Info> search(SearchDTO.SearchRq request);
}
