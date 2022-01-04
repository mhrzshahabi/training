package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.FileLabelDTO;
import com.nicico.training.iservice.IFileLabelService;
import com.nicico.training.model.FileLabel;
import com.nicico.training.repository.FileLabelDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FileLabelService implements IFileLabelService {

    private final FileLabelDAO fileLabelDAO;
    private final ModelMapper modelMapper;

    @Transactional
    @Override
    public FileLabelDTO.Info create(FileLabelDTO.Create create) {
        FileLabel entity = modelMapper.map(create, FileLabel.class);
        try {
            return modelMapper.map(fileLabelDAO.saveAndFlush(entity), FileLabelDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        Optional<FileLabel> optional = fileLabelDAO.findById(id);
        FileLabel fileLabel = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        try {
            fileLabelDAO.delete(fileLabel);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    public Set<FileLabel> getFileLabelByIds(Set<Long> ids) {
        Set<FileLabel> fileLabelSet = new HashSet<>();
        if (!ids.isEmpty()) {
            List<FileLabel> fileLabelList = fileLabelDAO.findAllById(ids);
            fileLabelSet = fileLabelList.stream().collect(Collectors.toSet());
        }
            return fileLabelSet;
    }

    @Override
    public Set<FileLabelDTO.Info> getFileLabelsInfo(Set<FileLabel> fileLabels) {
        Set<FileLabelDTO.Info> fileLabelsInfo = new HashSet<>();
        fileLabels.forEach(fileLabel -> {
            FileLabelDTO.Info fileLabelDTO = new FileLabelDTO.Info();
            fileLabelDTO.setId(fileLabel.getId());
            fileLabelDTO.setLabelName(fileLabel.getLabelName());
            fileLabelsInfo.add(fileLabelDTO);
        });
        return fileLabelsInfo;
    }

    @Override
    public List<FileLabel> findAll() {
        return fileLabelDAO.findAll();
    }
}
