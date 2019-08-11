package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CityDTO;
import com.nicico.training.iservice.ICityService;
import com.nicico.training.model.City;
import com.nicico.training.repository.CityDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CityService implements ICityService {
    private final ModelMapper modelMapper;
    private final CityDAO cityDAO;

    @Transactional(readOnly = true)
    @Override
    public CityDTO.Info get(Long id) {
        final Optional<City> gById = cityDAO.findById(id);
        final City city = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CityNotFound));
        return modelMapper.map(city, CityDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CityDTO.Info> list() {
        final List<City> gAll = cityDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<CityDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CityDTO.Info create(CityDTO.Create request) {
        final City city = modelMapper.map(request, City.class);
        return save(city);
    }

    @Transactional
    @Override
    public CityDTO.Info update(Long id, CityDTO.Update request) {
        final Optional<City> cById = cityDAO.findById(id);
        final City city = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        City updating = new City();
        modelMapper.map(city, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<City> one = cityDAO.findById(id);
        final City city = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        cityDAO.delete(city);
    }

    @Transactional
    @Override
    public void delete(CityDTO.Delete request) {
        final List<City> gAllById = cityDAO.findAllById(request.getIds());
        cityDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CityDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(cityDAO, request, city -> modelMapper.map(city, CityDTO.Info.class));
    }

    // ------------------------------

    private CityDTO.Info save(City city) {
        final City saved = cityDAO.saveAndFlush(city);
        return modelMapper.map(saved, CityDTO.Info.class);
    }
}
