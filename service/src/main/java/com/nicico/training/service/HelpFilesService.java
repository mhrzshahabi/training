package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.HelpFilesDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.helpFiles.HelpFilesBeanMapper;
import com.nicico.training.model.FileLabel;
import com.nicico.training.model.HelpFiles;
import com.nicico.training.repository.HelpFilesDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HelpFilesService implements IHelpFilesService {

    private final HelpFilesDAO helpFilesDAO;
    private final IFileLabelService iFileLabelService;
    private final HelpFilesBeanMapper helpFilesBeanMapper;


    @Transactional
    @Override
    public HelpFilesDTO.Info create(HelpFilesDTO.Create create) {

        HelpFiles helpFiles = helpFilesBeanMapper.toHelpFiles(create);
        try {
            return helpFilesBeanMapper.toHelpFilesInfo(helpFilesDAO.saveAndFlush(helpFiles));
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public HelpFiles update(HelpFilesDTO.Update update, Long id) {

        Optional<HelpFiles> helpFilesOptional = helpFilesDAO.findById(id);
        HelpFiles helpFiles = helpFilesOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        helpFiles.setDescription(update.getDescription());
        helpFiles.setFileLabels(iFileLabelService.getFileLabelByIds(update.getFileLabels()));
        return helpFilesDAO.saveAndFlush(helpFiles);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        helpFilesDAO.deleteById(id);
    }

    @Override
    public List<HelpFiles> findAll() {
        return helpFilesDAO.findAll();
    }

    @Override
    public List<HelpFiles> findAllByFileLabelIdsIn(Set<Long> labelIds) {
        Set<FileLabel> fileLabels = iFileLabelService.getFileLabelByIds(labelIds);
        return helpFilesDAO.findAllByFileLabelsIn(fileLabels).stream().collect(Collectors.toList());
    }
}
