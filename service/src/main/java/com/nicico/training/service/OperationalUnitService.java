package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalUnitDTO;
import com.nicico.training.iservice.IOperationalUnitService;
import com.nicico.training.model.OperationalUnit;
import com.nicico.training.repository.OperationalUnitDAO;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.jni.Local;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OperationalUnitService implements IOperationalUnitService {

    private final OperationalUnitDAO operationalUnitDAO;
    private final ModelMapper modelMapper;
    private final MessageSource messageSource;

    //*********************************

    @Transactional(readOnly = true)
    @Override
    public OperationalUnitDTO.Info get(Long id) {
        final Optional<OperationalUnit> optionalOperationalUnit = operationalUnitDAO.findById(id);
        final OperationalUnit operationalUnit = optionalOperationalUnit.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        return modelMapper.map(operationalUnit, OperationalUnitDTO.Info.class);
    }

    //*********************************

    @Transactional
    @Override
    public List<OperationalUnitDTO.Info> list() {
        List<OperationalUnit> operationalUnitList = operationalUnitDAO.findAll();
        return modelMapper.map(operationalUnitList, new TypeToken<List<OperationalUnitDTO.Info>>() {
        }.getType());
    }

    //*********************************

    @Transactional
    @Override
    public OperationalUnitDTO.Info create(OperationalUnitDTO.Create request, HttpServletResponse response) {

        OperationalUnitDTO.Info info = null;

        OperationalUnit operationalUnit = modelMapper.map(request, OperationalUnit.class);
        try {
            int count = operationalUnitDAO.countAllRecords();
            if (!operationalUnitDAO.existsByOperationalUnit(request.getOperationalUnit())) {
                if (count < 1000 ){
                    String formattedUnitCode = getFormat(count);
                    while (operationalUnitDAO.existsByUnitCode(formattedUnitCode)){
                        formattedUnitCode = getFormat(++count);
                    }
                    operationalUnit.setUnitCode(formattedUnitCode);

                    info = modelMapper.map(operationalUnitDAO.saveAndFlush(operationalUnit), OperationalUnitDTO.Info.class);
                }
                else {
                    Locale locale = LocaleContextHolder.getLocale();
                    response.sendError(403, messageSource.getMessage("more.than.maximum.capacity", null, locale));
                }
            }
            else {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(406, messageSource.getMessage("msg.record.duplicate", null, locale));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return info;
    }
    private String getFormat(int count) {
        return String.format("%03d", count + 1);
    }

    //*********************************

    @Transactional
    @Override
    public OperationalUnitDTO.Info update(Long id, OperationalUnitDTO.Update request, HttpServletResponse response) {

        OperationalUnitDTO.Info info = null;

        try {
            if (!operationalUnitDAO.existsByUnitCodeAndIdIsNotOrOperationalUnitAndIdIsNot(request.getUnitCode(), id, request.getOperationalUnit(), id)) {
                Optional<OperationalUnit> optionalOperationalUnit = operationalUnitDAO.findById(id);
                OperationalUnit currentOperationalUnit = optionalOperationalUnit.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
                OperationalUnit operationalUnit = new OperationalUnit();
                modelMapper.map(currentOperationalUnit, operationalUnit);
                modelMapper.map(request, operationalUnit);

                info = modelMapper.map(operationalUnitDAO.saveAndFlush(operationalUnit), OperationalUnitDTO.Info.class);

            } else {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(406, messageSource.getMessage("msg.record.duplicate", null, locale));

            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return info;
    }

    //*********************************

    @Transactional
    @Override
    public void delete(Long id) {
        operationalUnitDAO.deleteById(id);
    }

    //*********************************

    @Transactional
    @Override
    public void delete(OperationalUnitDTO.Delete request) {
        final List<OperationalUnit> operationalUnitList = operationalUnitDAO.findAllById(request.getIds());
        operationalUnitDAO.deleteAll(operationalUnitList);
    }

    //*********************************

    @Transactional
    @Override
    public SearchDTO.SearchRs<OperationalUnitDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(operationalUnitDAO, request, operationalUnit -> modelMapper.map(operationalUnit, OperationalUnitDTO.Info.class));
    }
}
