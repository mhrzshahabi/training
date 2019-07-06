package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.InstituteDTO;
import com.nicico.training.iservice.IInstituteService;
import com.nicico.training.model.Institute;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.InstituteDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class InstituteService implements IInstituteService {

    private final ModelMapper modelMapper;
    private final InstituteDAO instituteDAO;
    private final EnumsConverter.ELicenseTypeConverter eLicenseTypeConverter = new EnumsConverter.ELicenseTypeConverter();
    private final EnumsConverter.EInstituteTypeConverter eInstituteTypeConverter = new EnumsConverter.EInstituteTypeConverter();

    @Transactional(readOnly = true)
    @Override
    public InstituteDTO.Info get(Long id) {
        final Optional<Institute> gById = instituteDAO.findById(id);
        final Institute institute = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        return modelMapper.map(institute, InstituteDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<InstituteDTO.Info> list() {
        final List<Institute> gAll = instituteDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<InstituteDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public InstituteDTO.Info create(InstituteDTO.Create request) {
        final Institute institute = modelMapper.map(request, Institute.class);
        institute.setEInstituteType(eInstituteTypeConverter.convertToEntityAttribute(request.getEInstituteTypeId()));
        institute.setELicenseType(eLicenseTypeConverter.convertToEntityAttribute(request.getELicenseTypeId()));
        institute.setELicenseTypeTitleFa(institute.getELicenseType().getTitleFa());
        institute.setEInstituteTypeTitleFa(institute.getEInstituteType().getTitleFa());
        return modelMapper.map(instituteDAO.saveAndFlush(institute), InstituteDTO.Info.class);
    }

    @Transactional
    @Override
    public InstituteDTO.Info update(Long id, InstituteDTO.Update request) {
        final Optional<Institute> cById = instituteDAO.findById(id);
        final Institute institute = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        Institute updating = new Institute();
        modelMapper.map(institute, updating);
        modelMapper.map(request, updating);
        updating.setEInstituteType(eInstituteTypeConverter.convertToEntityAttribute(request.getEInstituteTypeId()));
        updating.setELicenseType(eLicenseTypeConverter.convertToEntityAttribute(request.getELicenseTypeId()));
        institute.setELicenseTypeTitleFa(institute.getELicenseType().getTitleFa());
        institute.setEInstituteTypeTitleFa(institute.getEInstituteType().getTitleFa());
        return modelMapper.map(instituteDAO.saveAndFlush(updating), InstituteDTO.Info.class);
    }


    @Transactional
    @Override
    public void delete(Long id) {
        instituteDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(InstituteDTO.Delete request) {
        final List<Institute> gAllById = instituteDAO.findAllById(request.getIds());
        instituteDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<InstituteDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(instituteDAO, request, institute -> modelMapper.map(institute, InstituteDTO.Info.class));
    }

    // ------------------------------

    private InstituteDTO.Info save(Institute institute) {
        final Institute saved = instituteDAO.saveAndFlush(institute);
        return modelMapper.map(saved, InstituteDTO.Info.class);
    }

   }
