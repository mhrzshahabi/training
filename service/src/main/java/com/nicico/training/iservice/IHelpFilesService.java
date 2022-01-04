package com.nicico.training.iservice;

import com.nicico.training.dto.HelpFilesDTO;
import com.nicico.training.model.HelpFiles;

import java.util.List;
import java.util.Set;

public interface IHelpFilesService {

    HelpFilesDTO.Info create(HelpFilesDTO.Create request);

    HelpFiles update(HelpFilesDTO.Update update, Long id);

    void delete(Long id);

    List<HelpFiles> findAll();

    List<HelpFiles> findAllByFileLabelIdsIn(Set<Long> labelIds);

}
