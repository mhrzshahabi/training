package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.PolisDTO;
import com.nicico.training.dto.ProvinceDTO;
import com.nicico.training.model.Polis;
import com.nicico.training.model.Province;
import com.nicico.training.repository.PolisDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class PolisService extends BaseService<Polis,Long,PolisDTO.Info,PolisDTO.Create,PolisDTO.Update,PolisDTO.Delete, PolisDAO>{

    @Autowired
    private ProvinceService provinceService;
    @Autowired
    private PolisDAO polisDAO;
    @Autowired
    private MessageSource messageSource;

    @Autowired
    PolisService(PolisDAO polisDAO){super(new Polis(),polisDAO);}

    @Transactional(readOnly = true)
    public PolisDTO.Info getInfo(Long id){
        Polis polis = super.get(id);
        return modelMapper.map(polis,PolisDTO.Info.class);
    }

    @Transactional
    public void delete(PolisDTO.Delete request) {
        final List<Polis> polises = polisDAO.findAllById(request.getIds());
        polisDAO.deleteAll(polises);
    }

    @Transactional
    public PolisDTO.Info safeCreate(PolisDTO.Create request, HttpServletResponse response){
        try{
            if(!polisDAO.existsByNameFa(request.getNameFa()))
                return super.create(request);
            else{
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(406, messageSource.getMessage("msg.record.duplicate", null, locale));
            }
        }catch (IOException e){
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        return null;
    }

    @Transactional
    public PolisDTO.Info safeUpdate(Long id, PolisDTO.Update request, HttpServletResponse response){
        try{
            if(!polisDAO.existsByNameFaAndIdIsNot(request.getNameFa(),id))
                return super.update(id, request);
            else{
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(406, messageSource.getMessage("msg.record.duplicate",null,locale));
            }
        }catch (IOException e){
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        return null;
    }
}
