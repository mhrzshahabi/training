package com.nicico.training.iservice;

import com.nicico.training.dto.FileLabelDTO;
import com.nicico.training.model.FileLabel;

import java.util.List;
import java.util.Set;

public interface IFileLabelService {

    FileLabelDTO.Info create(FileLabelDTO.Create create);

    void delete(Long id);

    Set<FileLabel> getFileLabelByIds(Set<Long> ids);

    Set<FileLabelDTO.Info> getFileLabelsInfo(Set<FileLabel> fileLabels);

    List<FileLabel> findAll();
}
