package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationLicenseDTO;
import com.nicico.training.iservice.IEducationLicenseService;
import com.nicico.training.model.EducationLicense;
import com.nicico.training.repository.EducationLicenseDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EducationLicenseService implements IEducationLicenseService {

    private final ModelMapper modelMapper;
    private final EducationLicenseDAO educationLicenseDAO;

    @Transactional(readOnly = true)
    @Override
    public EducationLicenseDTO.Info get(Long id) {
        final Optional<EducationLicense> gById = educationLicenseDAO.findById(id);
        final EducationLicense educationLicense = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationLicenseNotFound));
        return modelMapper.map(educationLicense, EducationLicenseDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EducationLicenseDTO.Info> list() {
        final List<EducationLicense> gAll = educationLicenseDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<EducationLicenseDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EducationLicenseDTO.Info create(EducationLicenseDTO.Create request) {
        final EducationLicense educationLicense = modelMapper.map(request, EducationLicense.class);
        return save(educationLicense);
    }

    @Transactional
    @Override
    public EducationLicenseDTO.Info update(Long id, EducationLicenseDTO.Update request) {
        final Optional<EducationLicense> cById = educationLicenseDAO.findById(id);
        final EducationLicense educationLicense = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        EducationLicense updating = new EducationLicense();
        modelMapper.map(educationLicense, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<EducationLicense> one = educationLicenseDAO.findById(id);
        final EducationLicense educationLicense = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        educationLicenseDAO.delete(educationLicense);
    }

    @Transactional
    @Override
    public void delete(EducationLicenseDTO.Delete request) {
        final List<EducationLicense> gAllById = educationLicenseDAO.findAllById(request.getIds());
        educationLicenseDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EducationLicenseDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(educationLicenseDAO, request, educationLicense -> modelMapper.map(educationLicense, EducationLicenseDTO.Info.class));
    }   

    // ------------------------------

    private EducationLicenseDTO.Info save(EducationLicense educationLicense) {
        final EducationLicense saved = educationLicenseDAO.saveAndFlush(educationLicense);
        return modelMapper.map(saved, EducationLicenseDTO.Info.class);
    }
}
