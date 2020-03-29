package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ProvinceDTO;
import com.nicico.training.iservice.IProvinceService;
import com.nicico.training.model.Province;
import com.nicico.training.repository.ProvinceDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProvinceService implements IProvinceService {

    private final ModelMapper modelMapper;
    private final ProvinceDAO provinceDAO;
    private final MessageSource messageSource;

    @Transactional(readOnly = true)
    @Override
    public ProvinceDTO.Info get(long id) {
        final Optional<Province> provinceOptional = provinceDAO.findById(id);
        final Province province = provinceOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.ProvinceNotFound));
        return modelMapper.map(province,ProvinceDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<ProvinceDTO.Info> list() {
        final List<Province> gAll = provinceDAO.findAll();
        return modelMapper.map(gAll,new TypeToken<List<ProvinceDTO.Info>>(){}.getType());
    }

    @Transactional
    @Override
    public ProvinceDTO.Info create(ProvinceDTO.Create request, HttpServletResponse response) {
        final Province province = modelMapper.map(request,Province.class);
        try {
            if(!provinceDAO.existsByNameFa(request.getNameFa()))
                return save(province);
            else{
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(406, messageSource.getMessage("msg.record.duplicate", null, locale));
            }
        }catch (ConstraintViolationException | DataIntegrityViolationException | IOException e){
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        return null;
    }

    @Transactional
    @Override
    public ProvinceDTO.Info update(Long id, ProvinceDTO.Update request, HttpServletResponse response) {
        final Optional<Province> optionalProvince = provinceDAO.findById(id);
        final Province province = optionalProvince.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.ProvinceNotFound));
        Province updating = new Province();
        modelMapper.map(province,updating);
        modelMapper.map(request,updating);
        try{
            if(!provinceDAO.existsByNameFaAndIdIsNot(request.getNameFa(),id))
                return save(updating);
            else{
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(406, messageSource.getMessage("msg.record.duplicate",null,locale));
            }
        }
        catch (ConstraintViolationException | DataIntegrityViolationException | IOException e){
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        return null;
    }

    @Transactional
    @Override
    public void delete(Long id) {
    final Optional<Province> optionalProvince = provinceDAO.findById(id);
    Province province = optionalProvince.orElseThrow(() -> new TrainingException((TrainingException.ErrorType.ProvinceNotFound)));
    try{
        provinceDAO.delete(province);
    }catch (ConstraintViolationException | DataIntegrityViolationException e){
        throw new TrainingException(TrainingException.ErrorType.NotDeletable);
    }
    }

    @Transactional
    @Override
    public void delete(ProvinceDTO.Delete request) {
        final List<Province> provinces = provinceDAO.findAllById(request.getIds());
        provinceDAO.deleteAll(provinces);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ProvinceDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(provinceDAO,request,Province -> modelMapper.map(Province,ProvinceDTO.Info.class));
    }

    // ------------------------------

    private ProvinceDTO.Info save(Province province){
        if(province.getNameEn() == null){
            province.setNameEn(" ");
        }
        final Province saved = provinceDAO.saveAndFlush(province);
        return modelMapper.map(saved,ProvinceDTO.Info.class);
    }

}
