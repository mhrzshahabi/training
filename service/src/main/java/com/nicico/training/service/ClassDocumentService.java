package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassDocumentDTO;
import com.nicico.training.iservice.IClassDocumentService;
import com.nicico.training.repository.ClassDocumentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ClassDocumentService implements IClassDocumentService {

    private final ClassDocumentDAO classDocumentDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ClassDocumentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(classDocumentDAO, request, classDocument -> modelMapper.map(classDocument, ClassDocumentDTO.Info.class));
    }

}
